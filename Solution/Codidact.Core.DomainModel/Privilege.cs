using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class Privilege
    {
        public Privilege()
        {
            MemberPrivilege = new HashSet<MemberPrivilege>();
        }

        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedat { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public string DisplayName { get; set; }
        public string Description { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual ICollection<MemberPrivilege> MemberPrivilege { get; set; }
    }
}
