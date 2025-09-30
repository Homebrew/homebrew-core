class Stanc3 < Formula
  desc "Stan transpiler"
  homepage "https://github.com/stan-dev/stanc3"
  url "https://github.com/stan-dev/stanc3.git",
      tag:      "v2.37.0",
      revision: "31d2a6e3a7a84e97a3bd8cabc205c76a063fb91f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a506ef69a644c723648740b9cf97b7c9f4c816cbba534afff9b6537d9ba8c418"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b75f859506655cb2629cee53326a56d2adf8990f5465b4b043d10a67723059f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6429a0f13f93478838dc9524af1246a844e2e3922ead3c8b0fadd9abc66124d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "966e95130f8a0695eab22f16796d4383f5e5aafbc35811008c3c848acdb077a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a4ee8620a6a19639f9e004d6e024464f8b95e86959d50c17165d027c1284f90"
    sha256 cellar: :any_skip_relocation, ventura:       "3b5e9cda6c9f7701747cca00dcc29c2f209b92c530e5f82ff0404e29481940f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7762a898b7afcb8f32cdf7b3fdcc2c02d991765067ff0c2942711cb557e602d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb5ab07bb40e6941e98d579dfc196f1294f0ae3f55a45a092aed2182a40e0e0d"
  end

  depends_on "ocaml@4" => :build # FIXME: pinned ppx_deriving.5.2.1 not compatible with OCaml >= 5.3
  depends_on "opam" => :build

  uses_from_macos "unzip" => :build

  # Workaround for error due to `-mpopcnt` on arm64 macOS with Xcode 16.3+.
  # TODO: Remove once base >= 0.17.3 or if fix is backported to 0.14 and released
  on_sequoia :or_newer do
    on_arm do
      resource "base" do
        url "https://github.com/janestreet/base/archive/refs/tags/v0.16.4.tar.gz"
        sha256 "200c053b69c04dd5cdc5bcb3ae27d098a88a311fb48c28d6382abe76e2a588f5"

        patch do
          url "https://github.com/janestreet/base/commit/68f18ed6a5e94dda1ed423c3435d1515259dcc7d.patch?full_index=1"
          sha256 "054fc30c7e748b2ad8ba8e2b8eead1309b8d7229821b57478cb604d5da5b69c6"
        end
      end
    end
  end

  def install
    ENV["OPAMROOT"] = buildpath/".opam"
    ENV["OPAMYES"] = "1"
    ENV["OPAMVERBOSE"] = "1"

    system "opam", "init", "--compiler=ocaml-system", "--disable-sandboxing", "--no-setup"
    # Workaround for https://github.com/janestreet/base/issues/164
    if OS.mac? && MacOS.version >= :sequoia
      resource("base").stage do
        system "opam", "install", ".", "--yes", "--no-depexts", "--working-dir"
      end
    end
    system "bash", "-x", "scripts/install_build_deps.sh"
    system "opam", "exec", "dune", "subst"
    system "opam", "exec", "dune", "build", "@install"

    bin.install "_build/default/src/stanc/stanc.exe" => "stanc"
  end

  test do
    resource "homebrew-testfile" do
      url "https://raw.githubusercontent.com/stan-dev/stanc3/2e833ac746a36cdde11b7041fe3a1771dec92ba6/test/integration/good/algebra_solver_good.stan"
      sha256 "44e66f05cc7be4d0e0a942b3de03aed1a2c2abd93dbd5607542051d9d6ae2a0b"
    end
    testpath.install resource("homebrew-testfile")

    system bin/"stanc", "algebra_solver_good.stan"
    assert_path_exists testpath/"algebra_solver_good.hpp"

    assert_match "stanc3 v#{version}", shell_output("#{bin}/stanc --version")
  end
end
