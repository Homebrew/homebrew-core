require "language/node"

class ZshHistoryEnquirer < Formula
  desc "Zsh plugin that enhances history search interaction"
  homepage "https://zsh-history-enquirer.zthxxx.me"
  url "https://registry.npmjs.org/zsh-history-enquirer/-/zsh-history-enquirer-1.3.0.tgz"
  sha256 "d2b673fdb0621bbbbae1529f42ff0c3184fa8e4f4befbc6bd9fa4b2d95ca4b5f"
  license "MIT"

  depends_on "node"

  on_linux do
    depends_on "expect" => :test
    depends_on "zsh"
  end

  resource "zsh-widget.test" do
    url "https://github.com/zthxxx/zsh-history-enquirer/raw/master/tests/zsh-widget.test.zsh"
    sha256 "1e20f9bedc3c3ae285f872e9fec2fa954bd9aae6211bc3159600c07c0a88c450"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    zsh_function.install "zsh-history-enquirer.plugin.zsh" => "history_enquire"
  end

  def caveats
    <<~EOS
      To activate zsh-history-enquirer, add the following to your .zshrc:
        autoload -U history_enquire
        history_enquire
    EOS
  end

  test do
    require "expect"

    testpath.install resource("zsh-widget.test")
    widget = testpath/"zsh-widget.test.zsh"
    chmod "+x", widget

    match = "ech"
    io = IO.popen(widget, "r")
    stdout = io.expect(match, 30)
    assert_match match, stdout&.last
  end
end
