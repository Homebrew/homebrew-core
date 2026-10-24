class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v15.6.2.tar.gz"
  sha256 "e7f5add92da555fc3120991fabd802c0605ab9c45cb4b56137dfb0699a006cec"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bb244ea50399b9891ae553e8566cdd0bc75649823223c809d3eb79b7b14e9aa4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3786a0d640769b6650fb4e02404e8b361b3cdadbc276b74560ab9f2d26c1262e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bd9ef5ae7dea6512ec2ae29a3016e4548a22cc990d428a07ddfc21f06d9d5b97"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a6bf98a335dc2004c08348eed07bc2b96b391ce3eb95122d5a51b1b3b2b3dcfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "13e3ccc67a1c2bf59b423f2e4d744effc6d3f4032f1e8cdb145638b70d58389c"
  end

  depends_on "dotnet"

  deny_network_access!

  def dotnet = deps.find { |d| d.name.match?(/^dotnet(@\d+)?$/) }.to_formula

  def libraries
    %w[
      TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj
      TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj
      TechnitiumLibrary.Security.OTP/TechnitiumLibrary.Security.OTP.csproj
    ]
  end

  def fetch
    ENV["XDG_RUNTIME_DIR"] = buildpath
    args = [
      "--use-current-runtime",
      "-p:TargetFrameworks=net#{dotnet.version.major_minor}",
    ]
    libraries.each { |library| system "dotnet", "restore", library, *args }
  end

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["XDG_RUNTIME_DIR"] = buildpath

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    libraries.each { |library| system "dotnet", "publish", library, *args }
  end

  test do
    # .NET named mutexes need `XDG_RUNTIME_DIR` (or `USER`) on Linux, which test containers may lack
    ENV["XDG_RUNTIME_DIR"] = testpath
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
