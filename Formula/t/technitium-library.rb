class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v15.2.0.tar.gz"
  sha256 "f8343e7906322a5f27e206069fd22d22e1c451f516d8c3c872d0d354bb00a445"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72a86d2786d7435beff31cef105818e42b8a7207d0bc7c51e7a1df9e5213db67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a34be55c30d2e03ae6ecbb4fdf3384d02a21b9577ae5c7ec8bd1902b375a3ba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f17003a5df31d401eb608533e1686d8d5863db9b2d5ad23a268c2027f8f0381d"
    sha256 cellar: :any_skip_relocation, sonoma:        "63d63a42ed67d268599d3dd80c0a5f03dc7eeaaac104015d90ea360ba4864e03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef6ecfce481425f705704411f420dce62c87ec35a8912b312d7777a7b433fab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91a732510450e5a58c0232257283ea6fabbefee40bcdc2abc0e47a5a4559a956"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    system "dotnet", "publish", "TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj", *args
    system "dotnet", "publish", "TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj", *args
    system "dotnet", "publish", "TechnitiumLibrary.Security.OTP/TechnitiumLibrary.Security.OTP.csproj", *args
  end

  test do
    dotnet = Formula["dotnet"]
    target_framework = "net#{dotnet.version.major_minor}"

    (testpath/"test.cs").write <<~CSHARP
      using System;
      using TechnitiumLibrary;

      namespace Homebrew
      {
        public class TechnitiumLibraryTest
        {
          public static void Main(string[] args)
          {
            Console.WriteLine(Base32.ToBase32HexString(new byte[] { 1, 2, 3 }));
          }
        }
      }
    CSHARP

    (testpath/"test.csproj").write <<~XML
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
        <ItemGroup>
          <Reference Include="TechnitiumLibrary">
            <HintPath>#{libexec}/TechnitiumLibrary.dll</HintPath>
          </Reference>
        </ItemGroup>
      </Project>
    XML

    system "#{dotnet.opt_libexec}/dotnet", "build", "--framework", target_framework,
           "--output", testpath, testpath/"test.csproj"
    output = shell_output("#{dotnet.opt_libexec}/dotnet run --framework #{target_framework} #{testpath}/test.dll")
    assert_match "04106===", output
  end
end
