class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.26.tar.gz"
  sha256 "3f05d7dc3af670f2fdc28f054c1d1313b81ad040134c10f9a57492b9dedc5314"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e84448b4bf134d17fd23f072d028c20366b7991edefdb83699b824ac1996d3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7658998bdcffb9ab79fd88166a00dbcbf9b6afb10a1aab9545bf420a6fd9e78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df36e62f2f4ace7b72c8e15f544ff653714c7f0ee5c9d1d9d32aa42b2769ac5d"
    sha256 cellar: :any_skip_relocation, ventura:        "a2a50a2774c143abcaafc5c62aa27a622a2d972441716df5842d331997c65120"
    sha256 cellar: :any_skip_relocation, monterey:       "928149a13adcf039d6e15fe744d086ff354f04870c0fa6337f5b93d23710f2c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "c43176a85f74631b66f79a3b43d8295782f0929e30ce82a40b711830308b9a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7948f687381c0929f493079ae824847e4d7570feb9c16e6ae9f5676fc8fe6b1"
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
