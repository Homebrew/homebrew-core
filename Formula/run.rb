class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.7.1.tar.gz"
  sha256 "43618d64860c5e962bd0b81e8a3b71085378dff162557dc237fa58595f1a0681"

  bottle do
    cellar :any_skip_relocation
    sha256 "f4a0ef6fe43ee3a9af1d526ddb07f977b257d6ba6ac544efdc789c4f50dc213c" => :catalina
    sha256 "f4a0ef6fe43ee3a9af1d526ddb07f977b257d6ba6ac544efdc789c4f50dc213c" => :mojave
    sha256 "f4a0ef6fe43ee3a9af1d526ddb07f977b257d6ba6ac544efdc789c4f50dc213c" => :high_sierra
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
