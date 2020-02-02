using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class Communities
    {
        public long Id { get; set; }
        public string Name { get; set; }
        public string Tagline { get; set; }
        public string Url { get; set; }
        public int Status { get; set; }
        public DateTime CreateDateAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long? DeletedByMemberId { get; set; }
        public bool IsDeleted { get; set; }
        public long? LastModifiedByMemberId { get; set; }
        public DateTime? DeletedAt { get; set; }
        public DateTime? LastModifiedAt { get; set; }
    }
}
