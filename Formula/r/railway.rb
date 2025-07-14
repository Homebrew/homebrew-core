class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.com/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v4.5.4.tar.gz"
  sha256 "c92c182fdb5ae9d29b481f2ed071dfd60632c46980a9c15a07e9ce1d2fd820c0"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bca0ea6380c5197f88ef81c127d331677a572c5c4c15cccb594cf4b26c6aebf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9a03808a170571ff45ec206b3720086c840fb21386be5e6394b92461b52183a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26fc8919d82e6d84baab11e2899f349102be27e2e29fe6c892d898e1e6786ceb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d36c78830c8ae13486bd6eb4dd66f354413634a05b9813575e9a7166e695cfc"
    sha256 cellar: :any_skip_relocation, ventura:       "66853bb9af630ea9a1a3245acbf24192768a244f31abd379c0811096a3c91d07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a538041c2e6e83e0ab68252f318c60ad19566667b788e736d1efe7594425733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f7adbd8e44439b9a30ebe063d347e9a90df5b218db6167ebc0ec2c1ea456e3c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1).chomp
    assert_match "Unauthorized. Please login with `railway login`", output

    assert_equal "railway #{version}", shell_output("#{bin}/railway --version").strip
  end
end
