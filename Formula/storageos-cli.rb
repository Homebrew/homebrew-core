class StorageosCli < Formula
  desc "StorageOS command-line adminstration tool"
  homepage "https://storageos.com/"
  url "https://github.com/storageos/go-cli/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "4b35c892e0ebf77d7be30441632eda404aa0e80cf5e0181d317c3557bb6629a3"
  license "MIT"

  depends_on "go" => :build

  def install
    # Make binary
    system "make", "build"
    bin.install "bin/storageos"
  end

  test do
    # <=2.4.0: mkdir(2) Library/Caches/storageos fails, as parents don't exist.
    system("mkdir -p $HOME/Library/Caches")

    assert_match "Storage for Cloud Native Applications.", shell_output("#{bin}/storageos")

    version_output = shell_output("#{bin}/storageos version")
    assert_match("StorageOS CLI version: #{version}", version_output.strip)
  end
end
