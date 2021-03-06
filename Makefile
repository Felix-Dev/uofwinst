REBOOTEXBIN = Rebootex_bin
REBOOTEX = Rebootex
INSTALLER = Installer
VSHCONTROL = Vshctrl
SYSTEMCONTROL = SystemControl
SYSTEMCONTROLPXE = PXE/SystemControlPXE
REBOOTEXPXE = PXE/RebootexPXE
LAUNCHER = PXE/Launcher
GALAXYDRIVER = ISODrivers/Galaxy
M33DRIVER = ISODrivers/March33
INFERNO = ISODrivers/Inferno
STARGATE = Stargate
ISOLAUNCHER = testsuite/ISOLauncher
FASTRECOVERY = FastRecovery
SATELITE = Satelite
POPCORN = Popcorn
RECOVERY = Recovery
PERMANENT = Permanent
CIPL = CIPL
CIPL_INSTALLER = CIPL_installer
USBDEVICE=usbdevice
CROSSFW = CrossFW
DISTRIBUTE = dist
CONFIG_660 = 1

ifeq ($(CONFIG_635), 1)
OPT_FLAGS+=CONFIG_635=1
endif

ifeq ($(CONFIG_620), 1)
OPT_FLAGS+=CONFIG_620=1
endif

ifeq ($(CONFIG_639), 1)
OPT_FLAGS+=CONFIG_639=1
endif

ifeq ($(CONFIG_660), 1)
OPT_FLAGS+=CONFIG_660=1
endif

ifeq ($(PSID_CHECK), 1)
RELEASE_OPTION=PSID_CHECK=1
endif

ifeq ($(DEBUG), 1)
DEBUG_OPTION=DEBUG=1
endif

ifeq ($(NIGHTLY), 1)
NIGHTLY_OPTION=NIGHTLY=1
endif

all:
# Preparing Distribution Folders
	@mkdir -p $(DISTRIBUTE) || true
	@mkdir -p $(DISTRIBUTE)/seplugins/ || true
	@cp -r contrib/fonts $(DISTRIBUTE)/seplugins/fonts || true
	@cp Translated/* $(DISTRIBUTE)/seplugins || true
	@mkdir -p $(DISTRIBUTE)/PSP || true
	@mkdir -p $(DISTRIBUTE)/PSP/GAME || true
	@mkdir -p $(DISTRIBUTE)/PSP/GAME/uOFW || true
	@rm -f ./Common/*.o

# Creating CrossFW library
	@cd $(CROSSFW); make $(OPT_FLAGS) $(DEBUG_OPTION)

# Creating Live-System Reboot Buffer
	@cd $(REBOOTEXBIN); make $(OPT_FLAGS)
	@cd $(REBOOTEX); make $(OPT_FLAGS) $(DEBUG_OPTION)

# Creating Live-System Components
	@cd $(RECOVERY); make $(OPT_FLAGS) $(DEBUG_OPTION)
	@rm -f ./Common/*.o
	@cd $(VSHCONTROL); make $(OPT_FLAGS) $(DEBUG_OPTION) $(NIGHTLY_OPTION)
	@cd $(USBDEVICE); make $(OPT_FLAGS) $(DEBUG_OPTION) $(NIGHTLY_OPTION)
	@cd $(SYSTEMCONTROL); make $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(GALAXYDRIVER); make $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(INFERNO); make $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(STARGATE); make $(OPT_FLAGS) $(DEBUG_OPTION) $(RELEASE_OPTION)
	@cd $(SATELITE); make $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(POPCORN); make $(OPT_FLAGS) $(DEBUG_OPTION)

# Creating PXE Executable
	@cd $(INSTALLER); make $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(SYSTEMCONTROLPXE); make $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(REBOOTEXPXE); make $(OPT_FLAGS)
	@mv $(REBOOTEXPXE)/rebootex.h $(LAUNCHER)
	@cd $(LAUNCHER); make $(OPT_FLAGS) $(DEBUG_OPTION)
	@mv $(LAUNCHER)/EBOOT.PBP $(DISTRIBUTE)/PSP/GAME/uOFW

clean:
	@cd $(REBOOTEXBIN); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(CROSSFW); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(REBOOTEX); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(INSTALLER); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(VSHCONTROL); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(USBDEVICE); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(SYSTEMCONTROL); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(GALAXYDRIVER); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(INFERNO); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(STARGATE); make clean $(OPT_FLAGS) $(DEBUG_OPTION) $(RELEASE_OPTION)
	@cd $(SATELITE); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(LAUNCHER); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(REBOOTEXPXE); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(SYSTEMCONTROLPXE); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(POPCORN); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@cd $(RECOVERY); make clean $(OPT_FLAGS) $(DEBUG_OPTION)
	@rm -rf $(DISTRIBUTE)

deps:
	make clean_lib
	make build_lib

build_lib:
	@cd $(SYSTEMCONTROL)/libs; make $(OPT_FLAGS) $(DEBUG_OPTION)
	
clean_lib:
	@cd $(SYSTEMCONTROL)/libs; make clean $(DEBUG_OPTION)
