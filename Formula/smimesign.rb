class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/0.0.7.tar.gz"
  sha256 "5f6dfcc8a412b979ba0d98f775cdb1b4d8209f5d60947ad9a8e710dca315b63e"

  bottle do
    cellar :any_skip_relocation
    sha256 "389336b4237065bbf7cc378041ca59b931d6da7752993d82e41b9b675c5506d7" => :mojave
    sha256 "2076e1029f2b8b37bcd407463730669e3a1de98daa296308e30ea4631526dc31" => :high_sierra
    sha256 "68bc853e01e2f1b2f20f118b01786d5d968d267e753eae50508eddd95a80f44c" => :sierra
  end

  depends_on "go" => :build
  depends_on :macos => :sierra

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/smimesign").install buildpath.children

    cd "src/github.com/github/smimesign" do
      system "go", "build", "-o", bin/"smimesign", "-ldflags", "-X main.versionString=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity", shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
