class Mosek < Formula
  desc "Mosek optimization software"
  homepage "https://www.mosek.com/"
  url "https://download.mosek.com/stable/11.2.2/mosektoolsosxaarch64.tar.bz2"
  sha256 "8aa38b87eda3463088611072986874275187586204940e269fa276a466e31ac8"
  license ""

  def install
    # Extract and install mosek
    prefix.install Dir["mosek/*"]
    
    # Link mosek bin directory to homebrew bin directory
    bin.install_symlink prefix/"11.2/tools/platform/osxaarch64/bin" => "mosek_bin"
    Dir["#{prefix}/11.2/tools/platform/osxaarch64/bin/*"].each do |file|
      next if File.directory?(file)
      bin.install_symlink file => File.basename(file)
    end
    
    # Link header files to homebrew include directory
    Dir["#{prefix}/11.2/tools/platform/osxaarch64/h/*.h"].each do |header|
      include.install_symlink header => File.basename(header)
    end
  end

  def post_install
    puts "Mosek installed successfully!"
    puts "Set MOSEKPLATFORM=osxaarch64 in your environment if needed"
    puts ""
    puts "⚠️  License Required: Mosek requires a license file to run."
    puts "Please request a license from https://www.mosek.com/products/mosek/"
    puts "and place the license file in #{ENV['HOME']}/mosek/mosek.lic"
    puts ""
    puts "Running Mosek installation script to set up Python bindings..."
    system "python", "#{prefix}/11.2/tools/platform/osxaarch64/bin/install.py"
  end

  test do
    system "#{bin}/mosek", "-v"
  end
end