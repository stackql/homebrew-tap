class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https://phrase.com/"
  url "https://github.com/phrase/phrase-cli/archive/refs/tags/2.6.5.tar.gz"
  sha256 "18b612ef36270fc1476fdbd3a1ef43282574fd172568b192121c95e38cdb2e05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "480a2d23f9343da01b1395b89a6bbdc1a00281761a97917204b03b474749635e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f589694900d98bba7347c71173b6a20fffc3bae687a54e88946aed9e14e822e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a0b336c7806268877e1ed76a3f457dc48be61a5ad3dbb1d4d61f5204bf974435"
    sha256 cellar: :any_skip_relocation, ventura:        "63f5046202bf6713b02de1e180300c6836fcaf6d4fefbbca1045b39a80941cc4"
    sha256 cellar: :any_skip_relocation, monterey:       "e1d2e93c502a5ce6b946f05921b9b0d2a85cb5f66b28e4006d08fffe7df8a7fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "10b4166610cdc573838435da95b7cdf076ad81d3068bfbd518727c7aed1d0691"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12b5e1dae01680411c1aa1cf9125d16eec791591b0f17c8686f538cae40c76ab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X=github.com/phrase/phrase-cli/cmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin/"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}/phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/phrase version")
  end
end
