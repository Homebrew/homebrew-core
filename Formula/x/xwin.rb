class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.6.3.tar.gz"
  sha256 "93f22bf0462c8b93511df53e49d3c5454bdd6cd9b8374250b32488587a52d3bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6119c0b75aedf0622229945d2be8538d656fd4bf5057fa369002cd82e31eff1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6e503f9ba2532c83bc3d24267ccf9019513dc36882a6624ad1f045196881689"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e58664a0416ed146bc1ccf71ec42a0c6c993177ca4beb2a58a0896bad38b7ec2"
    sha256 cellar: :any_skip_relocation, sonoma:         "28bcbde02e98b98f2fa8602769a7ab50b7468b1b6882b9b6a649ae7bd7ff8c59"
    sha256 cellar: :any_skip_relocation, ventura:        "bd612ed077f7b8554397a4d36b55a82725dc92c16ca23400d60bd8c299636a5c"
    sha256 cellar: :any_skip_relocation, monterey:       "caa5fd286f7f9a5dc51e12d4cdd82953b28ef6beaa1ed50cc8363d52c67ca3ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90278c7f0a54e6ac9d1f578ea5ca4c8aac999c0768c8da4b97cf49fb4a3ee3a9"
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
