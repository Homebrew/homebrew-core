class Ripmime < Formula
  desc "Extract attachments out of MIME encoded email packages"
  homepage "https://pldaniels.com/ripmime/"
  url "https://github.com/inflex/ripMIME/archive/refs/tags/1.4.1.0.tar.gz"
  sha256 "6d551d6b65b4da6c6b8dfd05be8141026cc760ca1fb8a707b7bf96c199c9f52d"
  license "BSD-3-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5736f080200de4ac8a01866619a98584ddb207bc38d62c41654c620bb4a8528e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d5c2db89d1a44f0e239ce29344d3c0fd8cf1bcb87323604a35637c216f74a2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dda645f1d8cc8b55fcb8fba6747ac3162330de3b50a6e42bb50859ce0d5bb383"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3cdf7a81580930011a430850659749515bf9f58eff2fa0c3589a47178c6f69e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3342a8eae88a0e8f24d5e87cda7d85b8dd4520161df950ada402e6ef7cc37b7"
    sha256 cellar: :any_skip_relocation, ventura:       "fb4d73a8f03ad7dcbc8cc4b72f41f8f81d918490e4bc94a712b47497adef35aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b083ab553fbe5c9106133acdd28ee36820df2352481e4188f1069e77d492d6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f64dee6f786e2e7a99a7fa792cce03ea36ba3b6604493f7e90e02a80670e5749"
  end

  def install
    args = %W[
      CFLAGS=#{ENV.cflags}
    ]
    args << "LIBS=-liconv" if OS.mac?
    system "make", *args
    bin.install "ripmime"
    man1.install "ripmime.1"
  end

  test do
    (testpath/"message.eml").write <<~EOS
      MIME-Version: 1.0
      Subject: Test email
      To: example@example.org
      Content-Type: multipart/mixed;
            boundary="XXXXboundary text"

      --XXXXboundary text
      Content-Type: text/plain;
      name="attachment.txt"
      Content-Disposition: attachment;
      filename="attachment.txt"
      Content-Transfer-Encoding: base64

      SGVsbG8gZnJvbSBIb21lYnJldyEK

      --XXXXboundary text--
    EOS

    system bin/"ripmime", "-i", "message.eml"
    assert_equal "Hello from Homebrew!\n", (testpath/"attachment.txt").read
  end
end
