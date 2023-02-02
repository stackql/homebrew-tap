class Stackql < Formula
  desc "SQL interface for arbitrary resources with full CRUD support"
  homepage "https://stackql.io/"
  url "https://github.com/stackql/stackql.git",
    tag:      "v0.3.265",
    revision: "ce58a3b9cd00022da42cb8144922613e9491f2f3"
  sha256 "46d00d6bc2c1e2d3351a10d0b753df0c0e87f9538f058cfc69f4f886ceac8725"
  license "MIT"

  depends_on "go@1.19" => :build

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = [
      "-s",
      "-w",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMajorVersion=0",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildMinorVersion=3",
      "-X github.com/stackql/stackql/internal/stackql/cmd.BuildPatchVersion=265",
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
