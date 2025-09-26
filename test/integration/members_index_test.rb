require "test_helper"

class MembersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = members(:michael)
    @non_admin = members(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get members_path
    assert_template "members/index"
    # Check if we have enough activated members to trigger pagination
    activated_members = Member.where(activated: true)
    if activated_members.count > Kaminari.config.default_per_page
      assert_select "nav"
      assert_select "ul.pagination"
    end
    # Check that the first page of activated members is displayed with delete links
    Member.where(activated: true).page(1).each do |member|
      assert_select "a[href=?]", member_path(member), text: member.name
      unless member == @admin
        assert_select "a[href=?]", member_path(member), text: "delete"
      end
    end
    assert_difference "Member.count", -1 do
      delete member_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get members_path
    assert_select "a", text: "delete", count: 0
  end
end
