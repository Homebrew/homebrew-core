class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/yorukot/superfile"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.1.7.1.tar.gz"
  sha256 "93f130813f15dd232a91424cb1100f0dcac69c02d838014bbc6b6093a81cd369"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35c60e7a5883e5c484ff5d8606c68fb0864c25dab84a8aa4f8ebc6cff101f162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "616d518bee99bae336d77d43729a80ac190730cf8acf13644fd1abeceaf1079c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c37dccafd15fbc883ddf1c7a2d4af6426a4f7d3132f024df687ca8aa7e123c09"
    sha256 cellar: :any_skip_relocation, sonoma:        "49d634b9ef8bfb3b1f9bd8ef559b6bdf6398083041f9177e1032ebaaf0cfd2a5"
    sha256 cellar: :any_skip_relocation, ventura:       "31cd0b7a24cfccf40fd4d2d56e6a102b0699ed8d21db49d0ed5f1239a2946acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4a951afe88f29d1e46bd71a938f2257217f0ac73af1c0bbbca83e121ac78bdb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end
