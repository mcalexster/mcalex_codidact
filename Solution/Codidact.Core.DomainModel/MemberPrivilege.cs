using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class MemberPrivilege
    {
        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public long MemberId { get; set; }
        public long PrivilegeId { get; set; }
        public bool IsSuspended { get; set; }
        public DateTime? PrivilegeSuspensionStartAt { get; set; }
        public DateTime? PrivilegeSuspensionEndAt { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual Member Member { get; set; }
        public virtual Privilege Privilege { get; set; }
    }
}
