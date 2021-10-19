require "language/node"

class Terminalizer < Formula
  desc "Record your terminal and generate animated gif images or share a web player"
  homepage "https://terminalizer.com/"
  url "https://registry.npmjs.org/terminalizer/-/terminalizer-0.7.2.tgz"
  sha256 "25ad22a9aa79e56192c3e0ede25fed40b5b9933ee07da4ee264357c1f6c85938"
  license "MIT"
  head "https://github.com/faressoft/terminalizer.git", branch: "master"

  depends_on "gcc"
  depends_on "python@3.9"
  on_macos do
    depends_on "node@14"
  end
  on_linux do
    depends_on "node"
  end

  fails_with gcc: "5"

  def install
    node = Formula["node"]
    node = Formula["node@14"] if OS.mac?
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"terminalizer").write_env_script libexec/"bin/terminalizer", PATH: "#{node.opt_bin}:$PATH"
  end

  test do
    output = shell_output("#{bin}/terminalizer --version")
    assert_match version.to_s, output.strip

    output = shell_output("#{bin}/terminalizer config")
    assert_match "config.yml", output.strip
    assert_predicate testpath/"config.yml", :exist?
  end
end
