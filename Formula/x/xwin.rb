class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.6.0.tar.gz"
  sha256 "f6fb9a9a4e78ae00426aa7faa90f60408dd581990c831e4d571be3eb1df92bf5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b565964c986063325a3ef38c8784190da3e9c47359eaf6f8e268a092dee45eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a38b6d437cedf3e1e78e04abe9a445072feb7891035ebf56ca75ceb93339ce8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "676fbdd6f90a792086ee090b75657b86940fcf2779b8a65d4cf86b70200c0644"
    sha256 cellar: :any_skip_relocation, sonoma:         "329ba8e9d762e1b3748ba0667749b45c88db4191ff396a0c10f28bd10d0c54f5"
    sha256 cellar: :any_skip_relocation, ventura:        "8131b6f3d05b3f3628eb502b4600a730c448e085330f066c608ac4500cfdf56a"
    sha256 cellar: :any_skip_relocation, monterey:       "76d0cbfd4f5b80ad85a34b7db70f1eb33f25357ba4db388727cc60f806e59c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85225655542d51af6db30ed0035a33cf5db030797940e003f38cac823029fbce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end
