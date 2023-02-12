class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
    tag:      "v0.3.293",
    revision: "d739e964a3f7ab917d774dd3fb6beb091abf2342"
  sha256 "ca28f4d8e4f0e90e03d939b21533a30b4b1fb8ef7fe3622c0587e43431dc2925"
  license "MIT"

  depends_on "go@1.19" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = [
      "-s",
      "-w",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=0",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=3",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=293",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildCommitSHA=#{Utils.git_head}",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildShortCommitSHA=#{Utils.git_short_head}",
      "-X \"stackql/internal/stackql/planbuilder.PlanCacheEnabled=true\"",
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "--tags", "json1 sqleanall", "./stackql"
  end

  test do
    assert_match "stackql #{version}", shell_output("stackql --version")
  end
end
