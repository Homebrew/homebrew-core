class Qtrn < Formula
  desc "Cli tool to streamline financial markets data analysis"
  homepage "https://github.com/FlashBoys/qtrn"
  url "https://github.com/FlashBoys/qtrn/archive/v0.3.tar.gz"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/FlashBoys/qtrn"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", "build/qtrn",
        "-ldflags",
        "'-X=github.com/FlashBoys/qtrn/version.Version=#{version}'"
      bin.install "build/qtrn"
    end
  end

  test do
    system bin/"qtrn", "-v"
  end
end
