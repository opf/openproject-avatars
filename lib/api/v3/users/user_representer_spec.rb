#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2017 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2017 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'

describe ::API::V3::Users::UserRepresenter do
  let(:user) { FactoryGirl.build_stubbed(:user, status: 1) }
  let(:current_user) { FactoryGirl.build_stubbed(:user) }
  let(:representer) { described_class.new(user, current_user: current_user) }

  context 'generation' do
    subject(:generated) { representer.to_json }

    describe 'avatar', with_settings: { protocol: 'http' } do
      before do
        allow(Setting).to receive(:plugin_openproject_avatars)
          .and_return(enable_gravatars: true)

        user.mail = 'foo@bar.com'
      end

      it 'should have an url to gravatar if settings permit and mail is set' do
        expect(parse_json(subject, 'avatar')).to start_with('http://gravatar.com/avatar')
      end

      it 'should be blank if gravatar is disabled' do
        allow(Setting).to receive(:gravatar_enabled?).and_return(false)

        expect(parse_json(subject, 'avatar')).to be_blank
      end

      it 'should be blank if email is missing (e.g. anonymous)' do
        user.mail = nil

        expect(parse_json(subject, 'avatar')).to be_blank
      end
    end
  end
end
