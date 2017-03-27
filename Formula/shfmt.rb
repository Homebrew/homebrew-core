class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v1.2.0.tar.gz"
  sha256 "3d2973f1adf99fcf65baae3c85697313a782dbedc2600fedb28687541a20ed43"
  head "https://github.com/mvdan/sh.git"
  depends_on "go" => :build

  def install
    version = "1.2.0"
    ENV["GOPATH"] = buildpath/".."
    mkdir_p buildpath/"../src/github.com/mvdan"
    mv buildpath/"../sh-#{version}", buildpath/"../src/github.com/mvdan/sh"
    mkdir buildpath/"sh-#{version}" # so cleanup doesn't fail
    cd buildpath/".." do
      system "go", "build", "-a", "-tags", "production brew", "github.com/mvdan/sh/cmd/shfmt"
      bin.install "shfmt"
    end
  end

  test do
    touch "shfmt-test-empty"
    system "#{bin}/shfmt", "shfmt-test-empty"
  end
end
