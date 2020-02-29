﻿using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class PostVote
    {
        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public long PostId { get; set; }
        public long VoteTypeId { get; set; }
        public long MemberId { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual Member Member { get; set; }
        public virtual Post Post { get; set; }
        public virtual VoteType VoteType { get; set; }
    }
}
