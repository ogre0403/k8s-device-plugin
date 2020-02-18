package main

import (
	cuda "github.com/mumax/3/cuda/cu"
	pluginapi "k8s.io/kubernetes/pkg/kubelet/apis/deviceplugin/v1beta1"
)

func getDevices() []*pluginapi.Device {
	n := cuda.DeviceGetCount()

	var devs []*pluginapi.Device
	for i := uint(0); i < uint(n); i++ {
		devs = append(devs, &pluginapi.Device{
			ID:     string(i),
			Health: pluginapi.Healthy,
		})
	}

	return devs
}

func deviceExists(devs []*pluginapi.Device, id string) bool {
	for _, d := range devs {
		if d.ID == id {
			return true
		}
	}
	return false
}
