class UpdateNuspec < Formula
  desc "Sync NuGet dependencies in nuspec files from csproj PackageReference versions"
  homepage "https://github.com/denis-peshkov/update-nuspec-action"
  url "https://github.com/denis-peshkov/update-nuspec-action/releases/download/v2.0.128/update-nuspec-2.0.128-src.tar.gz"
  sha256 "c573f7c3b41a495c64a48654b3285ecf89345e3e28c3647f4f65f72232e51f35"
  license "MIT"

  depends_on "rust" => :build

  def install
    cd "update-nuspec" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "update-nuspec", shell_output("#{bin}/update-nuspec --version")
  end
end
