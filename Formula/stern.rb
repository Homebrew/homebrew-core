class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.16.0.tar.gz"
  sha256 "c71af2141f8793b5be20e6068b6acc5c4ea58dffe0d5bb5a5973359d094ebf9b"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "234e2347df616e81646c74d168d0e1ce11b1e7a8cd7cb54d5e71e06c4b1bff95"
    sha256 cellar: :any_skip_relocation, big_sur:       "cd6c7cedf744d2436a58502186bf53c41bfe59b5049ff4c229ead7947a910b9e"
    sha256 cellar: :any_skip_relocation, catalina:      "8eb5b680678d6324aca6c33347c952375ad53712d7211ec6e9354e365dcf0b13"
    sha256 cellar: :any_skip_relocation, mojave:        "5c76df662b3d6225581abd431bb08f178d5db325d58a760cf5cf9177b30cd80f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/stern/stern/cmd.version=#{version}", *std_go_args

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
