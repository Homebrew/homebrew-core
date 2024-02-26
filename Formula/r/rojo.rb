class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.4.1",
      revision: "af9629c53f747022eba30d9a7abd0b08c2e6e186"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb9898b4e7d0a2d9e50eeaf027c0e7a733a8640beeac27c857eee21749545562"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1cd4f2917e1577ac3f6fad80738375e5017fae659eddb12872dfd27bfd58994"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1aaac2d832b296fb6890e587481691816acb0cf691fd4ca710118a040521ce6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2eb55c99777a8862df1936a8379edf572c2aa785c9796ac46316a9859da04980"
    sha256 cellar: :any_skip_relocation, ventura:        "83006bdadf3abea401f11c1338b6292ad26c8e8c06f74f04f8da7f93cdb18a65"
    sha256 cellar: :any_skip_relocation, monterey:       "4346010ca3c8f27cf47009dfb1799072a59f506b2daf4f6b65ceced95cdd284e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4623619463f1591d64b7c614601e88dc53b0ec85ce53e15cce47371a22abb02d"
  end

  depends_on "pkg-config" => :build
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
    assert_predicate testpath/"default.project.json", :exist?

    assert_match version.to_s, shell_output(bin/"rojo --version")
  end
end
