class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "92cc09febd2eebe90825b72ada0426510b6b372d61e4bef7a5df3e61eed59aeb"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72bf6cb31da4a7b3d939557e7d9636ef7fa581a3db9455e2abb38a14d7a3abb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d0f5a94f1496a484b5589cb60a728e509fd972adaa4a45dcb8c980dac2af96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8884b3c6399cc4999cb2f8afbc6408a5c80a63039076df809cfdb053f122f1d"
    sha256 cellar: :any_skip_relocation, ventura:        "047ccfaa16b8cc23b9b7e67d54d16989b61d086687e22509c681ded48b7ee59c"
    sha256 cellar: :any_skip_relocation, monterey:       "45984398b72f3ae69023947c3721d30996f69f8a28d1884290cf25b53619c8b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9bf21e3ddafe15539d021a5764392a952d893583b38bac62ca113420edeacd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9240e50fbad6366d44a784e726a1a3b02d19f2744e7b5eecd972f65ea990274"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"steampipe", "completion")
  end

  test do
    output = shell_output(bin/"steampipe service status 2>&1")
    if OS.mac?
      assert_match "Error: could not create installation directory", output
    else # Linux
      assert_match "Steampipe service is not installed", output
    end
    assert_match "Steampipe v#{version}", shell_output(bin/"steampipe --version")
  end
end
