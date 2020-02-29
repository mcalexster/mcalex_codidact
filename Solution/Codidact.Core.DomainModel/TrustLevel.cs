using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class TrustLevel
    {
        public TrustLevel()
        {
            Category = new HashSet<Category>();
            Member = new HashSet<Member>();
        }

        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public string DisplayName { get; set; }
        public string Explanation { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual ICollection<Category> Category { get; set; }
        public virtual ICollection<Member> Member { get; set; }
    }
}
