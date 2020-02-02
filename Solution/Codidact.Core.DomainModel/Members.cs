using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class Members
    {
        public long Id { get; set; }
        public string DisplayName { get; set; }
        public string Bio { get; set; }
        public string Email { get; set; }
        public string Location { get; set; }
        public bool IsFromStackExchange { get; set; }
        public long? StackExchangeId { get; set; }
        public bool IsEmailVerified { get; set; }
        public bool IsSuspended { get; set; }
        public DateTime CreateDateAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long? DeletedByMemberId { get; set; }
        public bool IsDeleted { get; set; }
        public long? LastModifiedByMemberId { get; set; }
        public DateTime? DeletedAt { get; set; }
        public DateTime? LastModifiedAt { get; set; }
        public DateTime? StackExchangeLastImportedAt { get; set; }
        public DateTime? StackExchangeValidatedAt { get; set; }
        public DateTime? SuspensionEndAt { get; set; }
    }
}
