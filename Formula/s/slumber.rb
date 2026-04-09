class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v5.2.4.tar.gz"
  sha256 "feefd7341026e78fad6025d8e2c3419071288bd3e6d8672e91b2d7023d58ba34"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ac41a5b0820b5f79ec50ecdeb02ba1692b4e3a65b9b2968b95c00c307dc96d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a319a7e28a8ed5b8d702ce8cf458573f2fd0bc1c160dfe18c6c9763895f412b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86565f70f8a8be3238d113ffabf1dc19c557ec80d4138499234d760154228be1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a7c061998946f8f398dbbe3226e39e6034a9e6a214dcc9d4a061eb1d730479cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d058109ecbdf77d26ad3cdd08e5eee11f677b159a1d2f17c7404aedfe56d1aac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91fdedb61a6d690cc3c2cc296a79d427a69529bb0efa9d53073cce9fa04d39e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end
