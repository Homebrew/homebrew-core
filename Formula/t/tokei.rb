class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/refs/tags/v14.0.0.tar.gz"
  sha256 "4e561dbb83ef1b46359714fc623fd45eddfb14821ece63a219470500fdd1cd26"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/XAMPPRocky/tokei.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4c00ab0590860aca31baefc4fc26bf12e31df2d767ff4f082fdbfdef062720c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50338ef998ef5c9c3aaf8832185361def1793e7a0b7992022da0bbf9e40db791"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c9bca298c011219d16cfec0bc5616441c50e561364b646303cbc3f54fd3708b"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e972212515cb41388ef0c41055a095d306f358f20c886c394443203a1a0ded4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043a8dd76dbc8b13e862d725b30e1989f05ffcefdf1c2d6b770daacb99bdd9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "827d4ca8ee4f3691311a0c9d2bbd410391e789868de263fdaf5929f4045238ad"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "all", *std_cargo_args
  end

  test do
    (testpath/"lib.rs").write <<~RUST
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    RUST
    system bin/"tokei", "lib.rs"
  end
end
