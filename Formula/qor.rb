class Qor < Formula
  desc "Cli v2 (using Go)"
  homepage "https://github.com/Qordobacode/Cli-v2"
  url "https://github.com/Qordobacode/Cli-v2/archive/version-0.2.tar.gz"
  sha256 "6e5f4e1a1a78c22a191101fd99259d0bbec0edde904b164e38edec129b8caaf4"
  head "https://github.com/Qordobacode/Cli-v2.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/qordobacode/cli-v2"
    src.install buildpath.children
    src.cd do
      system "go", "build", "-o", "#{bin}/qor"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "Qordoba Cli v4.0", shell_output("#{bin}/qor --version")
  end
end