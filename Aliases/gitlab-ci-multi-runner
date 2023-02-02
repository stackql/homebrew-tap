class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.8.0",
      revision: "66039dd945a2ab714242dcda254b3a999b57b469"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dbbc0740fbcdf27e811ac5c4533bd68a5da1a51faac3a23b52f5a181d072a03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5ce2853b513bfda11d209821484bc12e2269c96c56f0a1e5ec01a36fe665b92"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76a1f05b531421dfa5b109be2ccdfe65e3ab744c42ff824fbe13d9d8084d6c45"
    sha256 cellar: :any_skip_relocation, ventura:        "5852716d46552d8a119b63d7ec0145c00b3206ef4115aa4326003d93510f2e9e"
    sha256 cellar: :any_skip_relocation, monterey:       "6709b2734bccd4b4b94bda024b2d86b79b4856cf3e23e9035cc9ffd6065df10b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c129dfacc7922d99f48a7165eaf2b7bac5f15916d869f8e2e415fbc31027eff8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9a21476f3c6ddad877e5c0b16f281563f87a13e61844839fa71e22390b298a"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir Dir.home
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
