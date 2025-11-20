class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v14.1.0.tar.gz"
  sha256 "36da6c216a09874973b68ceb68f7e223d1708feb4339570023498112a3643211"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f9613d21241b14e3323a4dc71fbc1631ab24f56a8d61f60e6a81f6e02e21a31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91865cb5874441dab112c6e9267a3f5d2cc081194551bff59636d42dc9501dd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07697844a8f88098f9d137d01725c30da8e9254a0eb622146419a8d147d20561"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d59db73228efb8ee264679d107ded9c8ca33b3fa697a98f16364e98e6de0ae7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d376bc911451deb25373c99e92946358ba6dfda5ccac6c9f8a38c7e557e2ad5"
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
