class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https://usage.jdx.dev/"
  url "https://github.com/jdx/usage/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "012995fe781cca14d9aca64db4e795f3639051c4e674a30c416743945dbc89c9"
  license "MIT"
  head "https://github.com/jdx/usage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "066d30a9f308768d799bdacfee805ce4e7ce4f34ffc50079a981a75e45c750ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15328e0bc8320bdefa34864ec7bda63b5b70a3bc4bee3ecb1a2dff870a02f800"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c0e2d9c905fd6e19e12f69d344a5585a387a9f2f8de547aa90a171e5f2edaf1"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef9f6bfcda943f82bcbe6e96579da1920192fd341eaac55e414eb27882b59a6e"
    sha256 cellar: :any_skip_relocation, ventura:       "1c47718afc903afe19ada6804bfb0c5134fc5dfedc0521e9f810ef50d0819a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8f07809a2957e8b0cc55a793cd891f2c8e82c7704912366fd118b34d9da4ddc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin/"usage --version").chomp
    assert_equal "--foo", shell_output(bin/"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end
