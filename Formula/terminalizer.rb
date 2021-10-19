require "language/node"

class Terminalizer < Formula
  desc "Record your terminal and generate animated gif images or share a web player"
  homepage "https://terminalizer.com/"
  url "https://registry.npmjs.org/terminalizer/-/terminalizer-0.7.2.tgz"
  sha256 "25ad22a9aa79e56192c3e0ede25fed40b5b9933ee07da4ee264357c1f6c85938"
  license "MIT"
  head "https://github.com/faressoft/terminalizer.git", branch: "master"

  livecheck do
    url :stable
  end

  depends_on "gcc"
  depends_on "python@3.9"
  on_macos do
    depends_on "node@14"
  end
  on_linux do
    depends_on "node"
  end

  def install
    if OS.linux?
      gcc_major_ver = Formula["gcc"].any_installed_version.major
      ENV["CC"] = Formula["gcc"].opt_bin / "gcc-#{gcc_major_ver}"
      ENV["CXX"] = Formula["gcc"].opt_bin / "g++-#{gcc_major_ver}"
    end

    mkdir_p libexec / "lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/terminalizer --version")
    assert_match version.to_s, output.strip

    output = shell_output("#{bin}/terminalizer config")
    assert_match "config.yml", output.strip
    assert_predicate testpath/"config.yml", :exist?
  end
end
