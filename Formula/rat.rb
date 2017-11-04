class Rat < Formula
  desc "Compose shell commands to build terminal applications"
  homepage "https://github.com/ericfreese/rat/archive/v0.0.2.tar.gz"
  url "https://github.com/ericfreese/rat.git"
  version "0.0.2"
  sha256 "9da8d67a1e16056e3f05cdf536766e5571ede54a6c241c941d6c74eee5d64d31"

  depends_on "go" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/ericfreese/rat").install contents

    ENV["GOPATH"] = gopath

    cd gopath/"src/github.com/ericfreese/rat" do
      system "go", "build", "-o", "rat"
      bin.install "rat"
      prefix.install_metafiles
    end
  end

  test do
    system "[", "-x", "#{bin}/rat", "]"
  end
end
