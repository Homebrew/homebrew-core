class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.15.7.tar.gz"
  sha256 "aedbda7b897b1f27fe753220c8953931c22a582c4619ea1295bc0239c2996edc"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7af176c18fd8e36aa34ab10319eb062d8275e1963132a66b74eb86c3b9dcea6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09bf0f3feb09fbc8926e3a89d3ba7162c1e48efa0b425d133f57d5d5962b2483"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a36b45598f4a90a5205b7967ca83f8126dfdc16f15b241ef6e075c0ad3eaab78"
    sha256 cellar: :any_skip_relocation, ventura:        "8254a85c17fea07e4ad3eabaae5a0befd7aaa63ffcb75b6e566ce31748c95796"
    sha256 cellar: :any_skip_relocation, monterey:       "99ad4ecc889069db4d53460f19add042cd1213f6a710a52b327d0036c38ba0a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "86c7612fd8b9bd204fd904927b4a3cf671053175f1845ca5c1394a759a7b5fb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43e140e6f275bd4e46b3795b6a5eafbd39b4ddcb57bfea1fb892c82356e8245d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
