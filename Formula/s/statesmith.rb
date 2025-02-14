class Statesmith < Formula
  desc "State machine code generation tool suitable for bare metal, embedded and more"
  homepage "https://github.com/StateSmith/StateSmith"
  url "https://github.com/StateSmith/StateSmith/archive/refs/tags/cli-v0.17.4.tar.gz"
  sha256 "a4f86dcd9a1e59042f20e134e61f2af87534065ceb0a204f70b20e62eef1ab22"
  license "Apache-2.0"

  depends_on "dotnet" => :build

  def install
    os_arch =
      case RUBY_PLATFORM
      when /darwin/
        Hardware::CPU.arm? ? "osx-arm64" : "osx-x86_64"
      when /linux/
        Hardware::CPU.arm? ? "linux-arm64" : "linux-x86_64"
      else
        raise "Unsupported platform: #{RUBY_PLATFORM}"
      end

    chdir "src/StateSmith.Cli" do
      system "dotnet", "publish", "-c", "Release", "-p:PublishSingleFile=true", "--self-contained",
          "--framework", "net8.0", "/p:DefineConstants=SS_SINGLE_FILE_APPLICATION"
      bin.install "./bin/Release/net8.0/#{os_arch}/publish/StateSmith.Cli" => "ss.cli"
    end
  end

  test do
    system "#{bin}/ss.cli", "--version"
  end
end
