class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "dca0936384b8d0b22e9df667f8a1e8a114b224a5e303829fd943ef25d9845ef2"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3caaf0f83b47b90de2a84e5a39e7b66cc79557876470207f64094eccfe94b495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beaecd05158247bdda0be2b606ae94e05457d4582ae1e5e206aad88f79be514d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76e8030632a8cc3c26ca3e747a8e99810843cd4e599751a9f785678547859130"
    sha256 cellar: :any_skip_relocation, sonoma:        "8c02c15e45cf73d97d76f93c56d64b375c68407099a40c38da749764bdfa3422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1df114d38df0e11ef4d74921b1dbde8c7ac811839367320807624e4a95af41ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4602d2b51601b5a4d67ccc216f044659c897fc9d47a152e498e8c57c2c357ebd"
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
