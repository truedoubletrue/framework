pragma solidity ^0.4.19;

import 'zeppelin-solidity/contracts/ownership/rbac/Roles.sol';

contract MembershipAccessControl {
    
    using Roles for Roles.Role;

    // Memberships of each account
    enum MembershipType {ADMIN, OWNER, MANAGER, FOUNDER, INVESTOR}
        
    mapping (uint => Roles.Role) private memberships;
    
    event MembershipAdded(address addr, MembershipType memberType);
    event MembershipRemoved(address addr,  MembershipType memberType);
    
    function MembershipAccessControl() public {
        addMembership(msg.sender, MembershipType.OWNER);
        addMembership(msg.sender, MembershipType.ADMIN);
    }
    
    /**
      * @dev reverts if addr does not have membership
      * @param addr address
      * @param memberType the name of the membership
    */
    function checkMembership(address addr, MembershipType memberType) public canAdmin(msg.sender) {
        memberships[uint(memberType)].check(addr);
    }
    
    /**
      * @dev determine if addr has membership
      * @param addr address
      * @param memberType the name of the membership
      * @return bool
    */
    function hasMembership(address addr, MembershipType memberType) public canAdmin(msg.sender) returns (bool) {
        return memberships[uint(memberType)].has(addr);
    }

    /**
      * @dev add a membership to an address
      * @param addr address
      * @param memberType the name of the membership
    */
    function addMembership(address addr, MembershipType memberType) canAdmin(msg.sender) public {
        addMembershipInternal(addr, memberType);
    }

    /**
      * @dev remove a membership from an address
      * @param addr address
      * @param memberType the name of the membership
    */
    function removeMembership(address addr, MembershipType memberType) canAdmin(msg.sender) public {
        removeMembershipInternal(addr, memberType);
    }

    /**
      * @dev add a membership to an address
      * @param addr address
      * @param memberType the name of the membership
    */
    function addMembershipInternal(address addr, MembershipType memberType) internal {
        memberships[uint(memberType)].add(addr);
        MembershipAdded(addr, memberType);
    }

    /**
      * @dev remove a membership from an address
      * @param addr address
      * @param memberType the name of the membership
    */
    function removeMembershipInternal(address addr, MembershipType memberType) internal {
        memberships[uint(memberType)].remove(addr);
        MembershipRemoved(addr, memberType);
    }

    /**
      * @dev modifier to scope access to a single membership (uses msg.sender as addr)
      * @param memberType the name of the membership
      * // reverts
    */
    modifier onlyMembership(MembershipType memberType) {
        checkMembership(msg.sender, memberType);
        _;
    }
    
    modifier canAdmin(address _address) {
        require(hasMembership(_address, MembershipType.ADMIN));
        _;
    }
}
