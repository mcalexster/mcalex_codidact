using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class Category
    {
        public Category()
        {
            Post = new HashSet<Post>();
        }

        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public string DisplayName { get; set; }
        public string UrlPart { get; set; }
        public bool IsPrimary { get; set; }
        public string ShortExplanation { get; set; }
        public string LongExplanation { get; set; }
        public bool? ContributesToTrustLevel { get; set; }
        public long? Calculations { get; set; }
        public long ParticipationMinimumTrustLevelId { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual TrustLevel ParticipationMinimumTrustLevel { get; set; }
        public virtual ICollection<Post> Post { get; set; }
    }
}
