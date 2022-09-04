class Run < Formula
  desc "Easily manage and invoke small scripts and wrappers"
  homepage "https://github.com/TekWizely/run"
  url "https://github.com/TekWizely/run/archive/v0.9.0.tar.gz"
  sha256 "f7bd2dbcf41b27f67797c2b51291245f64dcf4aef243df205aed22f6f321c4d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61afb39ed4512657d3730411ad1e049f2b207f7c3f991eb63f992130f675a0a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61afb39ed4512657d3730411ad1e049f2b207f7c3f991eb63f992130f675a0a1"
    sha256 cellar: :any_skip_relocation, monterey:       "df7755e6e2254ad7b93a4dd7a8e001c2e7606bce62708ac799c89532ba3c1324"
    sha256 cellar: :any_skip_relocation, big_sur:        "df7755e6e2254ad7b93a4dd7a8e001c2e7606bce62708ac799c89532ba3c1324"
    sha256 cellar: :any_skip_relocation, catalina:       "df7755e6e2254ad7b93a4dd7a8e001c2e7606bce62708ac799c89532ba3c1324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb930fec55039f0cc35d8e24752eb30734692d476f9721e82841ebfea78e6e88"
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
