class Sco < Formula
    desc "sco是c#实现的解释型脚本,是一种高效,轻量,可嵌入的脚本语言,语法类似javascript,类型为弱类型,通过使用基于栈的虚拟机解释字节码来运行."
    homepage "https://github.com/qingfeng346/Scorpio-CSharp"
    license "GPL-3.0"
    if OS.mac? && Hardware::CPU.intel?
      url "https://github.com/qingfeng346/Scorpio-CSharp/releases/download/v2.3.5/sco-2.3.5-osx-x64.zip"
      sha256 "b3a66a4050139c6b7f9170420afe89845db6e521186f47e7fb10d49b5cf9b172"
    end
    if OS.mac? && Hardware::CPU.arm?
      url "https://github.com/qingfeng346/Scorpio-CSharp/releases/download/v2.3.5/sco-2.3.5-osx-arm64.zip"
      sha256 "00586f83f6c6bdadee033408c8cabe0ba0f2731b675a68960e02335d9f03313f"
    end
    if OS.linux? && Hardware::CPU.intel?
      url "https://github.com/qingfeng346/Scorpio-CSharp/releases/download/v2.3.5/sco-2.3.5-linux-x64.zip"
      sha256 "a106348dd5e6deb9ce0cff664b3bf23cb58be703d5773cdbe96a56309ef44631"
    end
    if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/qingfeng346/Scorpio-CSharp/releases/download/v2.3.5/sco-2.3.5-linux-arm64.zip"
      sha256 "1ce16069c9bea1e1c90533aa244652a29e7f8f63649db5d2d4201c1b6c65647e"
    end
    def install
      prefix.install Dir["*"]
      system "chmod","+x","#{prefix}/sco"
      bin.install_symlink "#{prefix}/sco"
    end
    test do
      system "#{prefix}/sco","version"
    end
end
