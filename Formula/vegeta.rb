class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag      => "v12.6.0",
      :revision => "fb2d8b9b724704ecf2ac86890de381bd98e6c941"

  bottle do
    cellar :any_skip_relocation
    sha256 "448919322a1dd870003a3953eaaea42139534024f98755a29d602e537b58caf0" => :mojave
    sha256 "398e443ae8f8d96d00315fd47888e59c1505820af33cc19e529d0f8f3918c026" => :high_sierra
    sha256 "44e7a0ef3154894e7468a99a6f208b6cdb17b3adfadcace4aadd27d16ac956e5" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/tsenart/vegeta"
    src.install buildpath.children
    src.cd do
      system "make", "vegeta"
      bin.install "vegeta"
      prefix.install_metafiles
    end
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end
