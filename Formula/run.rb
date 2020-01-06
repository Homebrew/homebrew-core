class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.7.0.tar.gz"
  sha256 "fd310e3eb61b975e754689731e7b8557c790506a309df80f5cd23a7019f9edc4"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca616a915230cf04423546409354267e4abc5082f1b8fd27e0fe77e5db4a6a7d" => :catalina
    sha256 "ca616a915230cf04423546409354267e4abc5082f1b8fd27e0fe77e5db4a6a7d" => :mojave
    sha256 "ca616a915230cf04423546409354267e4abc5082f1b8fd27e0fe77e5db4a6a7d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-ldflags", "-w -s", "-o", bin/name
  end

  test do
    text = "Hello Homebrew!"
    task = "hello"
    (testpath/"Runfile").write <<~EOS
      #{task}:
        echo #{text}
    EOS
    assert_equal text, shell_output("#{bin}/#{name} #{task}").chomp
  end
end
