class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.5.1",
      revision: "b2c4f550ee73985df05e5cca2595ff3d285d37ea"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "037768a1eca693218a58a335c29ec37d422b2b6b93d937cbec8e4beae26b5427"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "297641291ed8411808105c23187d9e7041d5b1932f6f0f005b1238c4adedd607"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4dc7549fc4c5457011ae775846ad419cbc7345bbc80e0aa0944f2c9e4175952"
    sha256 cellar: :any_skip_relocation, sonoma:        "902353caa2688965ac93fce1fb0257ff4153b2b89a752a833ecaf634b11ff8ab"
    sha256 cellar: :any_skip_relocation, ventura:       "e63a9354cc43e1ee5ad740d8289d04ead4c404ec8353bf62044cdabd130f3c0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad928d24b8478be1818222f9cabdaecb84a4a6b96ddd60cd18011b3b81bfbb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f9098f318c9d9d844b64aa223b69fca4c306fee098cc24ab97f4b2f66aa3203"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rojo", "init"
    assert_path_exists testpath/"default.project.json"

    assert_match version.to_s, shell_output(bin/"rojo --version")
  end
end
