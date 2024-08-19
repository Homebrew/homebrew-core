class SqlxCli < Formula
  desc "Command-line utility for SQLx, the Rust SQL toolkit"
  homepage "https://github.com/launchbadge/sqlx"
  url "https://github.com/launchbadge/sqlx/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "fffe09726fd225c0899c757bdbd5cad4481d63df6ca2f699a5aacd528cb01776"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2957863f4c5e75a7d466f568bca5e52a99bdf4295e91d62966f7787e533c8ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff1b198ca832c521236a3a85d5834a2c14ff4201d7c6a2e6664993d7965fa531"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbb22c392dd646d4d3c6ed63c3ce06f990889c8c053724c4ab43ce84354d0e96"
    sha256 cellar: :any_skip_relocation, sonoma:         "e37705fc94bafc2b55632be57b8c5a5912f3cb6c2773beded5cc44e76ae7a15f"
    sha256 cellar: :any_skip_relocation, ventura:        "d6157d665b629272c145a937e7ab6b8f6699b8471f109b85a59d74eceeb66af1"
    sha256 cellar: :any_skip_relocation, monterey:       "4d38d170fea25038c49a19d9da394afab970605f978757933f011d8634162b7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "053c7afb04bf5154e057d33de21b1b9e368fb8376867e489a16b0eba15da41fc"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "sqlx-cli")
  end

  test do
    ENV["DATABASE_URL"] = "postgres://postgres@localhost/my_database"
    assert_match "error: while resolving migrations: No such file or directory",
      shell_output("#{bin}/sqlx migrate info 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/sqlx --version")
  end
end
