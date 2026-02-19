class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.8.0.tar.gz"
  sha256 "e9671f13dbb0c4f5eeccaaf3d8406f198989e1e148942db2cf33c273e5767a3c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8a6670cf22f0c75ef89dad69374a5c0d77c148f86937dbf11fd9cebf1689892"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82e45aacb32a535ff473f1c8f10b1638d099f510c6e8c4901e8799017a1ea16e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35a2248f81f3f4e6fe9bba38491696d1aeb16615e9a0c2ae7a8eb974efa60c7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b282e5ecd683df4ca2ad0ee1e02decc0c4d2e0efcc0b2d6eb50901b5efbba8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adcb174309a3c7338015f5fb40b00d0eac2fb00641bc0d1e9e27781148f05601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68b1dcaf8e145135c5a4bc8b7dcb60abd9f3de8cb79d4cda58da6ff82f1a586a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_path_exists testpath/".xwin-cache/splat"
  end
end
