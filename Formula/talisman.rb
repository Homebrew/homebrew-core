class Talisman < Formula
  desc "Detects secrets checked into git repository before commit or push"
  homepage "https://thoughtworks.github.io/talisman/"
  url "https://github.com/thoughtworks/talisman/archive/v0.3.5.tar.gz"
  sha256 "7c71d5e4a98a5061598fadc9155ee02ae27d0a85f912273360d987a65d2c7362"

  depends_on "go" => :build
  depends_on "gox" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"
    talisman_path = buildpath/"src/github.com/thoughtworks/talisman"
    talisman_path.install buildpath.children

    cd talisman_path do
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox", "-osarch=darwin/#{arch}", "-ldflags=\"-X main.Version=v#{version}\"", "-output", bin/"talisman"
      bin.install "global_install_scripts/setup_talisman.bash"
      bin.install "global_install_scripts/uninstall_talisman.bash"
      onoe("The installation is not complete.")
      ohai("Please run the following command to complete the installation of Talisman:\n")
      ohai("\t\t /usr/local/Cellar/talisman/#{version}/bin/setup_talisman.bash\n")
    end
  end

  test do
    assert_equal "talisman Development Build\n", shell_output("#{bin}/talisman -v")
  end
end
