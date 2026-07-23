class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "f32b4bbcb624ac6d8b05feef5326a19797c8fce62f92e1b6f5185b8f01bc381d"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efea3427a7f4ce3cbd5f598672a34da7162def1833324f85d79242b75fccfc69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ecce930f4d6ed25b2809a71b16b9289e7bfb66eabe8ea6a39955f38d7c0e73d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce44d61126cfb54d7612d27603e20c60fdbf98597ee86c721cf759b9350b118e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cabe851cf7f568855be16d5073c2e2a0ead6c9250cda3a7021c07b46cb0b680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "862fa33ac0c32dd1e6da7a3d21a57e18ea24d5b706eb2a78be3cd2024c9cfcf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "408a60d52fd577589c51a41045dc0ff9cbd891337b736d9692582056017136da"
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
